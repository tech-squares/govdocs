# bylaws.perl - latex2html 2002 support for bylaws.cls
# by Stephen Gildea  Time-stamp: <2002-09-05 14:29:12 gildea>
# $Id$

package main;

$TOP_NAVIGATION = 0;
# 97.1 seems to ignore the variable, so we force the issue:
sub top_navigation_panel {}

$INFO = 0;
$NO_NAVIGATION = 0;
$MAX_SPLIT_DEPTH = 0;
$STYLESHEET = '';

# modified by secnames class option, see below
$BODYTEXT = "bgcolor=\"#fffff7\"";

# Class option [secnames] makes \section take an argument.
# Tested with latex2html 2K.1beta.
sub do_bylaws_secnames {
    $secnames = 1;
    # MITBDT-specific settings follow
    $mitbdt = 1;
    $BODYTEXT = "text=\"#000000\"" .
          " bgcolor=\"#f0f0f0\"" .
          " link=\"#ff0000\"" .
          " vlink=\"#800000\"";
}

# put the date at the bottom, not in the title
sub do_cmd_date {
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    ($bottom_date) = $&;
    $_;
}

sub do_env_history {
    local($_) = @_;
    s/\n/<br>\n/g;
    "<p align=\"center\">\n$_\n</p>";
}

$article_num = 0;

sub do_cmd_article{
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    local($artname) = $2;
    local($rest) = $_;
    $article_num++;
    $section_num = 0;
    $subsection_num = 0;
    local($romart) = &roman($article_num);
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    join('',
	$was_in_duty ? "</ul>\n" : "",
	"<h2 align=\"center\"><a name=\"article$article_num\">",
        "Article $romart.  $artname<\/a><\/h2>$rest");
}

sub do_cmd_policy{
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    local($artname) = $2;
    local($rest) = $_;
    $article_num++;
    $section_num = 0;
    $subsection_num = 0;
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    join('',
	$was_in_duty ? "</ul>\n" : "",
	"<h2 align=\"center\"><a name=\"sp$article_num\">",
        "Standing Policy $article_num.  $artname<\/a><\/h2>$rest");
}

sub do_cmd_subarticle{
    local($_) = @_;
    s/$next_pair_pr_rx//o;
    local($artname) = $2;
    local($rest) = $_;
    $section_num++;
    $subsection_num = 0;
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    join('',
	$was_in_duty ? "</ul>\n" : "",
	"<h3>Section $section_num.  $artname<\/h3>$rest");
}

$section_num = 0;

sub do_cmd_section{
    local($after) = @_;
    local($was_in_duty) = $in_duty;
    local($sectionname);
    $section_num++;
    $subsection_num = 0;
    $in_duty = 0;
    if ($secnames) {
	$after =~ s/$next_pair_rx//eo;
	$sectionname = $2;
    }
    join('',
	$was_in_duty ? "</ul>\n" : "",
	$secnames ?
	    "\n<h3>Section $section_num.  $sectionname<\/h3>" :
	    "<p>\nSection $section_num.  ",
	$after);
}

sub do_cmd_subsection{
    local($_) = @_;
    s/$next_pair_rx//eo;
    local($subsectionname) = $2;
    local($rest) = $_;
    $subsection_num++;
    local($alphsubsection) = &fAlph($subsection_num);
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    join('',
	$was_in_duty ? "</ul>\n" : "",
        "<p>\nSection $section_num.$alphsubsection.  ", $rest);
}

$in_duty = 0;

sub do_cmd_duty{
    local($_) = @_;
    local($was_in_duty) = $in_duty;
    $in_duty = 1;
    join('', 
	$was_in_duty ? "" : "<ul>\n",
        "<li>", $_);
}

sub do_env_issues {
    local($_) = @_;
    local($was_in_duty) = $in_duty;
    $in_duty = 0;
    join('',
	$was_in_duty ? "</ul>\n" : "",
        "\n<hr width=\"50%\" size=\"10\">\n<p>\n",
	"<h2 align=\"center\">Issues</h2>\n$_\n<p>");
}

sub do_cmd_issue{
    local($_) = @_;
    s/$next_pair_pr_rx//eo;
    local($issuenum) = $2;
    s/$next_pair_pr_rx//eo;
    local($issuename) = $2;
    # look ahead for the label we expect and fold it into the header
    local($label);
    if (s/$EOL\\label$any_next_pair_pr_rx$EOL//eo) {
	$label = $2;
    } else {
	$label = "Issue$issuenum";
    }
    local($rest) = $_;
    join('',
	 "\n<h3><a name=\"$label\">",
	 "Issue $issuenum: $issuename<\/a><\/h3>\n<p>$rest");
}

# comments are ignored
sub do_env_comment { ""; }

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

# &roman written by Stephen Gildea, May 1994, for tocfront program
sub roman {
    local($number) = @_;
    local($roman) = "";
    local(@romans) = ("M", 1000, "CM", 900, "D", 500, "CD", 400,
		      "C", 100, "XC", 90, "L", 50, "XL", 40,
		      "X", 10, "IX", 9, "V", 5, "IV", 4, "I", 1, "", 0);
    local($i);
    for ($i = 0; local($c, $val) = @romans[$i .. $i+1], $val; $i += 2) {
	while ($number >= $val) {
	    $number -= $val;
	    $roman .= $c;
	}
    }
    return $roman;
}

# not in V 96.1
# Should it be in latex2html ?
sub do_cmd_hrulefill {
    join('',"<hr>", $_[0]);
}

&ignore_commands(<<_IGNORED_CMDS_);
pagefooter # {}#{}#{}
leavevmode
voffset # &ignore_numeric_argument
NeedsTeXFormat #{}
null
_IGNORED_CMDS_

1;				# This must be the last line
