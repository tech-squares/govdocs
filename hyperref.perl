# hyperref.perl - latex2html support for hyperref.sty
# by Alex Dehnert

package main;

use Data::Dumper;

sub do_cmd_href {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    my $url = $2;
    s/$next_pair_pr_rx//o;
    my $text = $2;
    my $rest = $_;
    join('', '<a href="', $url, '">', $text, '</a>', $rest);
}

sub do_cmd_hyperref {
    local($_) = @_;
    my ($label, $label_pat) = get_next_optional_argument();
    s/$next_pair_pr_rx//o;
    my $text = $2;
    my $rest = $_;
    join('', '<a href="#', $label, '">', $text, '</a>', $rest);
}

# Allows setting title of a generated PDF. latex2html ~does this without the
# command, so our implementation is just a no-op to shut up the warning.
sub do_cmd_hypersetup {
}

1;

# vim: set filetype=perl:
