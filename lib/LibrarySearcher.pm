package lib::LibrarySearcher;

use Mouse;
use CGI;

has q => ( is => "rw" );
has left => ( is => "ro", default => "float: left;" );
has right => ( is => "ro", default => "float: right;" );

sub BUILD {
    my $self = shift;

    $self->q(CGI->new);
}

sub show {
    my $self = shift;

    print $self->q->start_div( {-class => "containt"} );

    print $self->q->start_div( {-class => "searchbox"} );
    print $self->q->start_form( -method => "POST" );
    print $self->q->p($self->q->textfield(-name => "hoge",
            -default => "starting values",
            -override => 1,
            -size => 50,
            -maxlength => 20));
    print $self->q->p($self->q->textfield(-name => "hoyo",
            -default => "starting values",
            -override => 1,
            -size => 50,
            -maxlength => 20));
    print $self->q->end_form;
    print $self->q->end_div;

    print "\n\n";

    print $self->q->start_div( {-class => "result"} );
    print $self->q->start_form( -method => "POST" );
    print $self->q->p($self->q->textfield(-name => "hoge",
            -default => "starting values",
            -override => 1,
            -size => 50,
            -maxlength => 20));
    print $self->q->p("AAA");
    print $self->q->end_form;
    print $self->q->end_div;

    print $self->q->end_div;
}

sub style {
    my $self = shift;

    my $text .= ".searchbox {\n";
    $text .= " " . $self->left . "\n";
    $text .= "}\n";
    $text .= ".result {\n";
    $text .= " " . $self->right . "\n";
    $text .= " color: #f0f0f0\n";
    $text .= "}\n";

    return $text;
}

1;
