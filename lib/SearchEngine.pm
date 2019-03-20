package lib::SearchEngine;

use Mouse;

use lib::ResultContaints;
use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Price;
use lib::Publisher;
use lib::Year;

has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has price => ( is => "rw" );
has results => ( is => "rw" );

sub explorer {
    my $self = shift;

    my $title = shift;
    my $author = shift;
    my $isbn = shift;
    my $publisher = shift;

    my $results = [];

    for (my $i = 0; $i < 1; $i++) {
        push @$results, $self->concrete_result;
    }

    $self->results($results);
}

sub concrete_result {
    my $self = shift;

    my $result = lib::ResultContaints->new;

    $result->title->default("AAA");
    # $result->author(lib::Author->new(default => $self->author));
    # $result->isbn(lib::ISBN->new(default => $self->isbn));
    # $result->price(lib::Price->new(default => "3,888円"));
    # $result->publisher(lib::Publisher->new(default => $self->publisher));
    # $result->year(lib::Year->new(default => 2018));

    $result->make_containts;

    return $result;
}

1;
