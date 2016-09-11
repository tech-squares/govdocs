package main;
use Data::Dumper;

$TOP_NAVIGATION = 0;
$INFO = 0;
$MAX_SPLIT_DEPTH = 0;
$STYLESHEET = '';

%standard_section_headings = (
    'part'          => 'H1',
    'chapter'       => 'H1',
    'section'       => 'H2',
    'subsection'    => 'H3',
    'subsubsection' => 'H4',
    'paragraph'     => 'H5',
    'subparagraph'  => 'H6',
);
print Dumper(\%standard_section_headings);

sub do_cmd_date {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($bottom_date) = $&;
    $_;
}

sub top_navigation_panel {}

sub bot_navigation_panel {
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    ($was_in_duty ? "</ul>\n" : "") .
    "<hr><p>\n".
    do {"$bottom_date<br>\n" if $bottom_date;}.
    do {'Up: <a href="./">Governing Documents Index</a><br>'."\n".
	'Top: <a href="../">Tech Squares</a>'."\n" if !$mitbdt;}
}

sub make_address {
    "</body>\n</html>\n";
}

1;
