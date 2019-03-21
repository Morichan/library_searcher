package lib::Publisher;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('出版社');
    $self->default('オライリー・ジャパン');
    $self->name("publisher");
}

1;
