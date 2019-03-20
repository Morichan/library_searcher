package lib::LibrarySearcher;

use Mouse;
use CGI;

use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Publisher;
use lib::SearchButton;
use lib::Result;

has q => ( is => "rw" );
has left => ( is => "ro", default => "float: left;" );
has right => ( is => "ro", default => "float: right;" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has search_button => ( is => "rw" );
has result => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->title(lib::Title->new);
    $self->author(lib::Author->new);
    $self->isbn(lib::ISBN->new);
    $self->publisher(lib::Publisher->new);
    $self->search_button(lib::SearchButton->new);
    $self->search_button->q($self->q);
    $self->result(lib::Result->new);
}

sub show {
    my $self = shift;

    $self->containts($self->print_searchbox, $self->print_result);
}

sub containts {
    my $self = shift;
    my $containts = \@_;

    print $self->q->start_div( {-class => "containts"} );

    foreach (@$containts) {
        print $_;
    }

    print $self->q->end_div;
}

sub print_searchbox {
    my $self = shift;

    return (
        $self->q->start_div( {-class => "searchbox"} ),
        $self->q->start_form( -method => "POST" ),
        $self->title->show,
        $self->author->show,
        $self->isbn->show,
        $self->publisher->show,
        $self->search_button->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub print_result {
    my $self = shift;

    if ($self->has_result) {
        $self->result->make_containts;
    }

    return $self->result->show;
}

sub has_result {
    my $self = shift;

    print $self->result->title($self->q->param("title") || "");

    return $self->result->has_result;
}

sub style {
    my $self = shift;

    my $text .= ".searchbox {\n";
    $text .= "  " . $self->left . "\n";
    $text .= "}\n";
    $text .= ".result {\n";
    $text .= "  " . $self->left . "\n";
    $text .= "}\n";
    $text .= "form {\n";
    $text .= "  margin-inline-start: 1em;\n";
    $text .= "  margin-inline-end: 1em;\n";
    $text .= "}\n";
    $text .= ".textfield {\n";
    $text .= "  margin-top: 0.5em;\n";
    $text .= "  margin-bottom: 0.5em;\n";
    $text .= "}\n";

    return $text;
}

1;
