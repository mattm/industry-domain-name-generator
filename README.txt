# Industry Domain Name Generator

This Ruby script uses the .com zone file to generate a list of high quality available domain names for a specific industry.

## Prerequisites

Before running, make sure you generate a `domains.txt` file with a list of all registered .com domain names and place it in same directory as the script.

For instructions on how to generate the list, check out [Extracting a List of All Registered .com Domains from the Verisign Zone File
](https://mattmazur.com/2018/05/18/extracting-a-list-of-all-registered-com-domains-from-the-verisign-zone-file/).

## How this Works

Check out this blog post...

## Running the Script

1) In `generator.rb`, modify these two constants:

* `INDUSTRY` - This is the industry you want to generate a domain for
* `SIMILAR_INDUSTRIES` - These are other industries whose names you want to check the availability of.

For example, if `INDUSTRY` is "marketing" and `SIMILAR_INDUSTRIES` is "advertising", "media", and "consulting", this will find all common registered names for the similar industries, then check which of those are not registred for "marketing".

2) From the command line, run `ruby generator.rb`.

3) The results will be in the results directory such as `results/marketing.txt`

## Contact

If you have any suggestions, find a bug, or just want to say hey drop me a note at [@mhmazur](https://twitter.com/mhmazur) on Twitter or by email at matthew.h.mazur@gmail.com.

## License

MIT © [Matt Mazur](http://mattmazur.com)


