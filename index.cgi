#!/usr/bin/perl

use strict;
use warnings;

use CGI;

=head1 index.cgi

図書検索システムWebページのindexページです。

=head1 AUTHOR

森敬介

2018年度 修了生

=cut



&main;



sub main {
    my $q = new CGI;

    print $q->header( -charset => "utf-8" );
    print $q->start_html( -title => "title", -lang => "ja", -encoding => "utf-8" );
    print $q->h1("Hello, world!");
    print $q->end_html();
}

