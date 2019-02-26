package lib::LibrarySearcher;

use Mouse;
use CGI;

use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Publisher;
use lib::ResultArea;

has q => ( is => "rw" );
has left => ( is => "ro", default => "float: left;" );
has right => ( is => "ro", default => "float: right;" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
}

sub show {
    my $self = shift;

    $self->containts($self->searchbox, $self->result);
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

sub searchbox {
    my $self = shift;
    my $title = lib::Title->new;
    my $author = lib::Author->new;
    my $isbn = lib::ISBN->new;
    my $publisher = lib::Publisher->new;

    return (
        $self->q->start_div( {-class => "searchbox"} ),
        $self->q->start_form( -method => "POST" ),
        $title->show,
        $author->show,
        $isbn->show,
        $publisher->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub result {
    my $self = shift;
    my $result_area = lib::ResultArea->new;

    return (
        $self->q->start_div( {-class => "result"} ),
        $self->q->start_form( -method => "POST" ),
        $result_area->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
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
