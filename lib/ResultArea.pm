package lib::ResultArea;

use Mouse;
use CGI;

has q => ( is => "rw" );
has name => ( is => "ro", default => "result" );
has default => ( is => "ro", default => "ここに結果を出力します。\n\nタイトル:\n著者:\nISBN:\n価格:\n出版社:\n出版年:\n\n全ての項目を埋める必要はありません。" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
}

sub show {
    my $self = shift;

    return $self->q->p(
        $self->q->start_div({-class => "result"}),
        $self->q->textarea(
            -name => $self->name,
            -default => $self->default,
            -rows => 50,
            -columns => 50),
        $self->q->end_div,
        "\n");
}

1;
