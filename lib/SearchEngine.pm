package lib::SearchEngine;

use utf8;
use Mouse;
use URI;
use LWP::UserAgent;
use XML::LibXML;

use lib::ResultContaints;

has uri => ( is => "rw", isa => "URI", default => sub { URI->new('http://iss.ndl.go.jp/api/sru') } );
has ua => ( is => "rw", isa => "LWP::UserAgent", default => sub { LWP::UserAgent->new } );
has xml => ( is => "rw", isa => "XML::LibXML", default => sub { XML::LibXML->new } );
has title => ( is => "rw", isa => "Str" );
has author => ( is => "rw", isa => "Str" );
has isbn => ( is => "rw", isa => "Str" );
has publisher => ( is => "rw", isa => "Str" );
has results => ( is => "rw" );
has is_error => ( is => "rw" );

sub explorer {
    my $self = shift;

    if (@_ == 4) {
        $self->title(shift);
        $self->author(shift);
        $self->isbn(shift);
        $self->publisher(shift);
    }

    my $results = [];
    $self->is_error(0);

    my $data = $self->search_book;

    # if ($self->is_error) {
    #     $self->results("Timeout!");
    #     return;
    # }

    $results = $self->concrete_results($data);

    $self->results($results);
}

sub search_book {
    my $self = shift;

    $self->ua->timeout(10); # second (not ms)

    # $self->uri(URI->new("http://iss.ndl.go.jp/api/sru?operation=searchRetrieve&query=title%3d\"perl\"%20AND%20creator%3d\"phoenix\"&recordSchema=dcndl_simple"));
    $self->uri->query_form({
            operation => "searchRetrieve",
            query => $self->create_queries,
            recordSchema => "dcndl_simple",
            maximumRecords => 200
        });

    my $response;

    eval {
        $response = $self->ua->get($self->uri);
    };

    if ($response->is_error) {
        print "Timeout";
        $self->is_error(1);
        return;
    }

    my $response_data = $self->xml->parse_string($response->content);
    my @book_data = $response_data->getElementsByTagName("dcndl_simple:dc");

    return \@book_data;
}

sub create_queries {
    my $self = shift;

    my @queries;

    if ($self->title) {
        push @queries, $self->create_query("title", $self->title);
    }

    if ($self->author) {
        push @queries, $self->create_query("creator", $self->author);
    }

    if ($self->isbn) {
        push @queries, $self->create_query("isbn", $self->isbn);
    }

    if ($self->publisher) {
        push @queries, $self->create_query("publisher", $self->publisher);
    }

    return join(" AND ", @queries);
}

sub create_query {
    my $self = shift;
    my $title = shift;
    my $param = shift;

    return "$title=\"$param\"";
}

sub concrete_results {
    my $self = shift;
    my $data = shift;

    my $results = [];

    foreach my $datum (@$data) {
        my $result = lib::ResultContaints->new;
        $result->title->value($self->make_title($datum));
        $result->author->value($self->make_author($datum));
        $result->isbn->value($self->make_isbn($datum));
        $result->price->value($self->make_price($datum));
        $result->publisher->value($self->make_publisher($datum));
        $result->year->value($self->make_year($datum));
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
        if (index($text, "ISBN") != -1) {
            return $text->textContent;
        }
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
