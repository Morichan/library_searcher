package lib::LibrarySearcher;

use utf8;
use Mouse;
use CGI;
use CSS::Tiny;

use lib::Title;
use lib::Author;
use lib::ISBN;
use lib::Publisher;
use lib::SearchButton;
use lib::OptionMenu;
use lib::Result;

has q => ( is => "rw", isa => "CGI", required => 1 );
has css => ( is => "rw", isa => "CSS::Tiny", default => sub { CSS::Tiny->new } );
has left => ( is => "ro", default => sub { { float => "left" } } );
has class_name => ( is => "ro", default => "library_searcher" );
has searchbox_class_name => ( is => "ro", default => "searchbox" );
has has_input => ( is => "rw", default => 0 );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has search_button => ( is => "rw" );
has option_menu => ( is => "rw" );
has result => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->title(lib::Title->new( q => $self->q ));
    $self->author(lib::Author->new( q => $self->q ));
    $self->isbn(lib::ISBN->new( q => $self->q ));
    $self->publisher(lib::Publisher->new( q => $self->q ));
    $self->search_button(lib::SearchButton->new( q => $self->q ));
    $self->option_menu(lib::OptionMenu->new( q => $self->q ));
    $self->result(lib::Result->new( q => $self->q ));
}

sub show {
    my $self = shift;

    $self->has_input(0);
    $self->print_html($self->show_searchbox, $self->show_result);
}

sub print_html {
    my $self = shift;
    my $containts = \@_;

    print $self->q->start_div( { -class => $self->class_name } );

    foreach (@$containts) {
        print $_;
    }

    print $self->q->end_div;
}

sub show_searchbox {
    my $self = shift;

    return (
        $self->q->start_div( { -class => $self->searchbox_class_name } ),
        $self->q->start_form( -method => "POST" ),
        $self->title->show,
        $self->author->show,
        $self->isbn->show,
        $self->publisher->show,
        $self->search_button->show,
        $self->option_menu->show,
        $self->q->end_form,
        $self->q->end_div,
        "\n\n");
}

sub show_result {
    my $self = shift;

    $self->get_parameters;

    if ($self->has_input) {
        $self->result->make_containts_list;
    }

    return $self->result->show;
}

sub get_parameters {
    my $self = shift;

    $self->result->title($self->q->param("title") || "");
    $self->result->author($self->q->param("author") || "");
    $self->result->isbn($self->q->param("isbn") || "");
    $self->result->publisher($self->q->param("publisher") || "");

    $self->has_input($self->result->has_input);
}

sub style {
    my $self = shift;

    $self->css->{$self->dot($self->searchbox_class_name)} = $self->left;
    $self->css->{$self->dot($self->result->class_name)} = $self->left;

    $self->css->{"form"} = {
        "margin-inline-start" => "1em",
        "margin-inline-end" => "1em"
    };

    $self->css->{$self->dot($self->title->class_name)} = {
        "margin-top" => "0.5em",
        "margin-bottom" => "0.5em"
    };

    $self->css->{$self->dot($self->search_button->class_name)} = {
        "margin-top" => "0.5em",
        "margin-bottom" => "0.5em"
    };

    $self->css->{$self->dot($self->option_menu->class_name)} = {
        "margin-top" => "0.5em",
        "margin-bottom" => "0.5em"
    };
    $self->css->{$self->dot($self->option_menu->class_name) . " input"} = {
        display => "none"
    };
    $self->css->{$self->dot($self->option_menu->class_name) . " " .
            $self->dot($self->option_menu->menu_class_name)} = {
        height => 0,
        padding => 0,
        overflow => "hidden",
        opacity => 0,
        transition => "0.8s"
    };
    $self->css->{$self->dot($self->option_menu->class_name) . " input:checked ~ " .
            $self->dot($self->option_menu->menu_class_name)} = {
        padding => "10px 0",
        height => "auto",
        opacity => 1
    };

    return $self->css->write_string;
}

sub dot {
    my $self = shift;
    my $class_name = shift;

    return "." . $class_name;
}

1;
