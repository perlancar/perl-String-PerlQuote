package String::PerlQuote;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       single_quote
                       double_quote
               );

# BEGIN COPY PASTE FROM Data::Dump
my %esc = (
    "\a" => "\\a",
    "\b" => "\\b",
    "\t" => "\\t",
    "\n" => "\\n",
    "\f" => "\\f",
    "\r" => "\\r",
    "\e" => "\\e",
);

# put a string value in double quotes
sub double_quote {
  local($_) = $_[0];
  # If there are many '"' we might want to use qq() instead
  s/([\\\"\@\$])/\\$1/g;
  return qq("$_") unless /[^\040-\176]/;  # fast exit

  s/([\a\b\t\n\f\r\e])/$esc{$1}/g;

  # no need for 3 digits in escape for these
  s/([\0-\037])(?!\d)/sprintf('\\%o',ord($1))/eg;

  s/([\0-\037\177-\377])/sprintf('\\x%02X',ord($1))/eg;
  s/([^\040-\176])/sprintf('\\x{%X}',ord($1))/eg;

  return qq("$_");
}
# END COPY PASTE FROM Data::Dump

sub single_quote {
  local($_) = $_[0];
  s/([\\'])/\\$1/g;
  return qq('$_');
}
1;
# ABSTRACT: Quote a string like Perl does

=head1 FUNCTIONS

=head2 double_quote($str) => STR

Quote or encode C<$str> to the Perl double quote (C<">) literal representation
of the string. Example:

 say double_quote("a");        # => "a"     (with the quotes)
 say double_quote("a\n");      # => "a\n"
 say double_quote('"');        # => "\""
 say double_quote('$foo');     # => "\$foo"

This code is taken from C<quote()> in L<Data::Dump>. Maybe I didn't look more
closely, but I couldn't a module that provides a function to do something like
this. L<String::Escape>, for example, provides C<qqbackslash> but it does not
escape C<$>.

=head2 single_quote($str) => STR

Like C<double_quote> but will produce a Perl single quote literal representation
instead of the double quote ones. In single quotes, only literal backslash C<\>
and single quote character C<'> are escaped, the rest are displayed as-is, so
the result might span multiple lines or contain other non-printable characters.

 say single_quote("Mom's");    # => 'Mom\'s' (with the quotes)
 say single_quote("a\\");      # => 'a\\"
 say single_quote('"');        # => '"'
 say single_quote("\$foo");    # => '$foo'

=cut
