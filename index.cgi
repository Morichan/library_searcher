#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use lib::Index;

=head1 index.cgi

図書検索システムWebページのindexページです。

=head1 AUTHOR

森敬介

2018年度 修了生

=cut



&main;



sub main {
    my $index = lib::Index->new;

    $index->show;
}

