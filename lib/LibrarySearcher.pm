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

has q => ( is => "rw" );
has css => ( is => "rw" );
has left => ( is => "rw" );
has class_name => ( is => "ro", default => "library_searcher" );
has searchbox_class_name => ( is => "ro", default => "searchbox" );
has title => ( is => "rw" );
has author => ( is => "rw" );
has isbn => ( is => "rw" );
has publisher => ( is => "rw" );
has search_button => ( is => "rw" );
has option_menu => ( is => "rw" );
has result => ( is => "rw" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
    $self->css(CSS::Tiny->new);
    $self->left({ float => "left" });
    $self->title(lib::Title->new);
    $self->author(lib::Author->new);
    $self->isbn(lib::ISBN->new);
    $self->publisher(lib::Publisher->new);
    $self->search_button(lib::SearchButton->new);
    $self->search_button->q($self->q);
    $self->option_menu(lib::OptionMenu->new);
    $self->option_menu->q($self->q);
    $self->result(lib::Result->new);
}

sub show {
    my $self = shift;

    $self->containts($self->print_searchbox, $self->print_result);
}

sub containts {
    my $self = shift;
    my $containts = \@_;

    print $self->q->start_div( { -class => $self->class_name } );

    foreach (@$containts) {
        print $_;
    }

    print $self->q->end_div;
}

sub print_searchbox {
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

sub print_result {
    my $self = shift;

    if ($self->has_input) {
        $self->result->make_containts_list;
    }

    return $self->result->show;
}

sub has_input {
    my $self = shift;

    $self->result->title($self->q->param("title") || "");
    $self->result->author($self->q->param("author") || "");
    $self->result->isbn($self->q->param("isbn") || "");
    $self->result->publisher($self->q->param("publisher") || "");

    return $self->result->has_input;
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
