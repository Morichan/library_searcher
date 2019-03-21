package lib::SearchEngine;

use utf8;
use Mouse;
use URI;
use LWP::UserAgent;
use XML::LibXML;

use lib::ResultContaints;
use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Price;
use lib::Publisher;
use lib::Year;

has ua => ( is => "rw" );
has json => ( is => "rw" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has results => ( is => "rw" );

sub explorer {
    my $self = shift;

    my $title = shift;
    my $author = shift;
    my $isbn = shift;
    my $publisher = shift;

    my $results = [];

    my $data = $self->search_book($title, $author, $isbn, $publisher);

    $results = $self->concrete_results($data);

    $self->results($results);
}

sub search_book {
    my $self = shift;

    my $title = shift;
    my $author = shift;
    my $isbn = shift;
    my $publisher = shift;

    # $self->uri("http://iss.ndl.go.jp/api/sru?operation=searchRetrieve&query=title%3d\"perl\"%20AND%20creator%3d\"phoenix\"&recordSchema=dcndl_simple");
    my $uri = URI->new('http://iss.ndl.go.jp/api/sru');
    $uri->query_form({
            operation => "searchRetrieve",
            query => $self->create_query($title, $author, $isbn, $publisher),
            recordSchema => "dcndl_simple",
            maximumRecords => 200
        });

    # print $uri->as_string;
    my $ua = LWP::UserAgent->new;
    my $xml = XML::LibXML->new;

    # print "<p>".$uri->as_string."<p>";

    $ua->timeout(10); # second (not ms)
    my $response_xml = $ua->get($uri)->content;

    my $response_data = $xml->parse_string($response_xml);

    my @book_data = $response_data->getElementsByTagName("dcndl_simple:dc");
    return \@book_data;
}

sub create_query {
    my $self = shift;

    my $title = shift;
    my $author = shift;
    my $isbn = shift;
    my $publisher = shift;

    my @queries;

    if ($title) {
        my $query .= 'title="';
        $query .= $title;
        $query .= '"';
        push @queries, $query;
    }

    if ($author) {
        my $query .= 'creator="';
        $query .= $author;
        $query .= '"';
        push @queries, $query;
    }

    if ($isbn) {
        my $query .= 'isbn="';
        $query .= $isbn;
        $query .= '"';
        push @queries, $query;
    }

    if ($publisher) {
        my $query .= 'publisher="';
        $query .= $publisher;
        $query .= '"';
        push @queries, $query;
    }

    return join(" AND ", @queries);
}

sub concrete_results {
    my $self = shift;
    my $data = shift;

    my $results = [];

    foreach my $datum (@$data) {
        my $result = lib::ResultContaints->new;
        $result->title->default($self->make_title($datum));
        $result->author->default($self->make_author($datum));
        $result->isbn->default($self->make_isbn($datum));
        $result->price->default($self->make_price($datum));
        $result->publisher->default($self->make_publisher($datum));
        $result->year->default($self->make_year($datum));
        $result->make_containts;

        push @$results, $result;
    }

    return $results;
}

sub make_title {
    my $self = shift;
    my $datum = shift;

    $datum->getElementsByTagName("dc:title")->[0]->textContent;
}

sub make_author {
    my $self = shift;
    my $datum = shift;

    my @authors;

    foreach my $author ($datum->getElementsByTagName("dc:creator")) {
        push @authors, $author->textContent;
    }

    return join(", ", @authors);
}

sub make_isbn {
    my $self = shift;
    my $datum = shift;

    foreach my $text ($datum->getElementsByTagName("dc:identifier")) {
        return $text->textContent if index($text, "ISBN") != -1;
    }

    return "";
}

sub make_price {
    my $self = shift;
    my $datum = shift;

    return $self->check_null_array($datum->getElementsByTagName("dcndl:price"));
}

sub make_publisher {
    my $self = shift;
    my $datum = shift;

    return $self->check_null_array($datum->getElementsByTagName("dc:publisher"));
}

sub make_year {
    my $self = shift;
    my $datum = shift;

    return $self->check_null_array($datum->getElementsByTagName("dcterms:issued"));
}

sub check_null_array {
    my $self = shift;
    my @data = @_;

    if (@data) {
        return $data[0]->textContent;
    } else {
        return "";
    }
}

1;
