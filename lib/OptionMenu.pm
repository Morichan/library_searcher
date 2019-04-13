package lib::OptionMenu;

use utf8;
use Mouse;

has q => ( is => "rw" );
has class_name => ( is => "ro", default => "option_menu" );
has menu_class_name => ( is => "ro", default => "hidden_menu" );

sub show {
    my $self = shift;

    return (
        $self->q->start_div( { -class => $self->class_name } ),
        $self->q->label( { -for => "hidden_menu_label" }, "詳細設定" ),
        $self->q->input( { -type => "checkbox", -id => "hidden_menu_label" } ),
        $self->q->start_div( { -class => $self->menu_class_name }),
        "MenuItem",
        $self->q->end_div,
        $self->q->end_div
    );
}

1;
