# weather.py version 1.4, http://fungi.yuggoth.org/weather/
# Copyright (c) 2006-2008 Jeremy Stanley <fungi@yuggoth.org>.
# Permission to use, copy, modify, and distribute this software is
# granted under terms provided in the LICENSE file distributed with
# this software.

"""Contains various object definitions needed by the weather utility."""

version = "1.4"

class Selections:
   """An object to contain selection data."""
   def __init__(self):
      """Store the config, options and arguments."""
      self.config = get_config()
      self.options, self.arguments = get_options(self.config)
      if self.arguments:
         self.arguments = [(x.lower()) for x in self.arguments]
      else: self.arguments = [ None ]
   def get(self, option, argument=None):
      """Retrieve data from the config or options."""
      if not argument: return self.options.__dict__[option]
      elif not self.config.has_section(argument):
         import sys
         sys.stderr.write("weather: error: no alias defined for " \
            + argument + "\n")
         sys.exit(1)
      elif self.config.has_option(argument, option):
         return self.config.get(argument, option)
      else: return self.options.__dict__[option]
   def get_bool(self, option, argument=None):
      """Get data and coerce to a boolean if necessary."""
      return bool(self.get(option, argument))

def bool(data):
   """Coerce data to a boolean value."""
   if type(data) is str:
      if eval(data): return True
      else: return False
   else:
      if data: return True
      else: return False

def quote(words):
   """Wrap a string in quotes if it contains spaces."""
   if words.find(" ") != -1: words = "\"" + words + "\""
   return words

def sorted(data):
   """Return a sorted copy of a list."""
   new_copy = data[:]
   new_copy.sort()
   return new_copy

def get_url(url):
   """Return a string containing the results of a URL GET."""
   import urllib2
   try: return urllib2.urlopen(url).read()
   except urllib2.URLError:
      import sys, traceback
      sys.stderr.write("weather: error: failed to retrieve\n   " \
         + url + "\n   " + \
         traceback.format_exception_only(sys.exc_type, sys.exc_value)[0])
      sys.exit(1)

def get_metar(id, verbose=False, quiet=False, headers=None, murl=None):
   """Return a summarized METAR for the specified station."""
   if not id:
      import sys
      sys.stderr.write("weather: error: id required for conditions\n")
      sys.exit(1)
   if not murl:
      murl = \
         "http://weather.noaa.gov/pub/data/observations/metar/decoded/%ID%.TXT"
   murl = murl.replace("%ID%", id.upper())
   murl = murl.replace("%Id%", id.capitalize())
   murl = murl.replace("%iD%", id)
   murl = murl.replace("%id%", id.lower())
   murl = murl.replace(" ", "_")
   metar = get_url(murl)
   if verbose: return metar
   else:
      lines = metar.split("\n")
      if not headers:
         headers = \
            "relative_humidity," \
            + "precipitation_last_hour," \
            + "sky conditions," \
            + "temperature," \
            + "weather," \
            + "wind"
      headerlist = headers.lower().replace("_"," ").split(",")
      output = []
      if not quiet:
         output.append("Current conditions at " \
            + lines[0].split(", ")[1] + " (" \
            + id.upper() +")")
         output.append("Last updated " + lines[1])
      for header in headerlist:
         for line in lines:
            if line.lower().startswith(header + ":"):
               if line.endswith(":0"):
                  line = line[:-2]
               if quiet: output.append(line)
               else: output.append("   " + line)
      return "\n".join(output)

def get_forecast(city, st, verbose=False, quiet=False, flines="0", furl=None):
   """Return the forecast for a specified city/st combination."""
   if not city or not st:
      import sys
      sys.stderr.write("weather: error: city and st required for forecast\n")
      sys.exit(1)
   if not furl:
      furl = "http://weather.noaa.gov/pub/data/forecasts/city/%st%/%city%.txt"
   furl = furl.replace("%CITY%", city.upper())
   furl = furl.replace("%City%", city.capitalize())
   furl = furl.replace("%citY%", city)
   furl = furl.replace("%city%", city.lower())
   furl = furl.replace("%ST%", st.upper())
   furl = furl.replace("%St%", st.capitalize())
   furl = furl.replace("%sT%", st)
   furl = furl.replace("%st%", st.lower())
   furl = furl.replace(" ", "_")
   forecast = get_url(furl)
   if verbose: return forecast
   else:
      lines = forecast.split("\n")
      output = []
      if not quiet: output += lines[2:4]
      flines = int(flines)
      if not flines: flines = len(lines) - 5
      for line in lines[5:flines+5]:
         if line.startswith("."):
            if quiet: output.append(line.replace(".", "", 1))
            else: output.append(line.replace(".", "   ", 1))
      return "\n".join(output)

def get_options(config):
   """Parse the options passed on the command line."""

   # for optparse's builtin -h/--help option
   usage = "usage: %prog [ options ] [ alias [ alias [...] ] ]"

   # for optparse's builtin --version option
   verstring = "%prog " + version

   # create the parser
   import optparse
   option_parser = optparse.OptionParser(usage=usage, version=verstring)

   # the -c/--city option
   if config.has_option("default", "city"):
      default_city = config.get("default", "city")
   else: default_city = ""
   option_parser.add_option("-c", "--city",
      dest="city",
      default=default_city,
      help="the city name (ex: \"Raleigh Durham\")")

   # the --flines option
   if config.has_option("default", "flines"):
      default_flines = config.get("default", "flines")
   else: default_flines = "0"
   option_parser.add_option("--flines",
      dest="flines",
      default=default_flines,
      help="maximum number of forecast lines to show")

   # the -f/--forecast option
   if config.has_option("default", "forecast"):
      default_forecast = bool(config.get("default", "forecast"))
   else: default_forecast = False
   option_parser.add_option("-f", "--forecast",
      dest="forecast",
      action="store_true",
      default=default_forecast,
      help="include a local forecast")

   # the --furl option
   if config.has_option("default", "furl"):
      default_furl = config.get("default", "furl")
   else:
      default_furl = \
         "http://weather.noaa.gov/pub/data/forecasts/city/%st%/%city%.txt"
   option_parser.add_option("--furl",
      dest="furl",
      default=default_furl,
      help="forecast URL (including %city% and %st%)")

   # the --headers option
   if config.has_option("default", "headers"):
      default_headers = config.get("default", "headers")
   else:
      default_headers = \
         "temperature," \
         + "relative_humidity," \
         + "wind," \
         + "weather," \
         + "sky_conditions," \
         + "precipitation_last_hour"
   option_parser.add_option("--headers",
      dest="headers",
      default=default_headers,
      help="the conditions headers to display")

   # the -i/--id option
   if config.has_option("default", "id"):
      default_id = config.get("default", "id")
   else: default_id = ""
   option_parser.add_option("-i", "--id",
      dest="id",
      default=default_id,
      help="the METAR station ID (ex: KRDU)")

   # the -l/--list option
   option_parser.add_option("-l", "--list",
      dest="list",
      action="store_true",
      default=False,
      help="print a list of configured aliases")

   # the --murl option
   if config.has_option("default", "murl"):
      default_murl = config.get("default", "murl")
   else:
      default_murl = \
         "http://weather.noaa.gov/pub/data/observations/metar/decoded/%ID%.TXT"
   option_parser.add_option("--murl",
      dest="murl",
      default=default_murl,
      help="METAR URL (including %id%)")

   # the -n/--no-conditions option
   if config.has_option("default", "conditions"):
      default_conditions = bool(config.get("default", "conditions"))
   else: default_conditions = True
   option_parser.add_option("-n", "--no-conditions",
      dest="conditions",
      action="store_false",
      default=default_conditions,
      help="disable output of current conditions (forces -f)")

   # the -o/--omit-forecast option
   option_parser.add_option("-o", "--omit-forecast",
      dest="forecast",
      action="store_false",
      default=default_forecast,
      help="omit the local forecast (cancels -f)")

   # the -q/--quiet option
   if config.has_option("default", "quiet"):
      default_quiet = bool(config.get("default", "quiet"))
   else: default_quiet = False
   option_parser.add_option("-q", "--quiet",
      dest="quiet",
      action="store_true",
      default=default_quiet,
      help="skip preambles and don't indent")

   # the -s/--st option
   if config.has_option("default", "st"):
      default_st = config.get("default", "st")
   else: default_st = ""
   option_parser.add_option("-s", "--st",
      dest="st",
      default=default_st,
      help="the state abbreviation (ex: NC)")

   # the -v/--verbose option
   if config.has_option("default", "verbose"):
      default_verbose = bool(config.get("default", "verbose"))
   else: default_verbose = False
   option_parser.add_option("-v", "--verbose",
      dest="verbose",
      action="store_true",
      default=default_verbose,
      help="show full decoded feeds (cancels -q)")

   # separate options object from list of arguments and return both
   options, arguments = option_parser.parse_args()
   return options, arguments

def get_config():
   """Parse the aliases and configuration."""
   import ConfigParser
   config = ConfigParser.ConfigParser()
   import os.path
   rcfiles = [
      "/etc/weatherrc",
      os.path.expanduser("~/.weatherrc"),
      "weatherrc"
      ]
   import os
   for rcfile in rcfiles:
      if os.access(rcfile, os.R_OK): config.read(rcfile)
   for section in config.sections():
      if section != section.lower():
         if config.has_section(section.lower()):
            config.remove_section(section.lower())
         config.add_section(section.lower())
         for option,value in config.items(section):
            config.set(section.lower(), option, value)
   return config

def list_aliases(config):
   """Return a formatted list of aliases defined in the config."""
   sections = []
   for section in sorted(config.sections()):
      if section.lower() not in sections and section != "default":
         sections.append(section.lower())
   output = "configured aliases..."
   for section in sorted(sections):
      output += "\n   " \
         + section \
         + ": --id=" \
         + quote(config.get(section, "id")) \
         + " --city=" \
         + quote(config.get(section, "city")) \
         + " --st=" \
         + quote(config.get(section, "st"))
   return output

