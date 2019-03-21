package lib::Title;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('タイトル');
    $self->default('初めてのPerl');
    $self->name("title");
}

1;
