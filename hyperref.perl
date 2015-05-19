# hyperref.perl - latex2html support for hyperref.sty
# by Alex Dehnert

package main;

use Data::Dumper;

sub do_cmd_url {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    my $url = $2;
    my $rest = $_;
    print Dumper($1, $2, $3, $4, $5, $6);
    join('', '<a href="', $url, '">', $url, '</a>', $rest);
}

sub do_cmd_href {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    my $url = $2;
    s/$next_pair_pr_rx//o;
    my $text = $2;
    my $rest = $_;
    join('', '<a href="', $url, '">', $text, '</a>', $rest);
}

1;
