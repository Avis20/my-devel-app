package MyApp::Controller::Callback::Telegram;
use Moose;
use namespace::autoclean;

use uni::perl       qw| :dumper |;
use Encode          qw| encode decode |;
use JSON::XS        qw| decode_json encode_json |;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => 'callback');

sub webhook : Chained('base') : PathPart('webhook') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{json_data} = { success => 0 };
    return unless ref $c->req->body;
    open my $fh, $c->req->body->filename;
    my $body = decode_json( join('', map { chomp; encode('UTF-8',$_) } <$fh> ) || '{}' );
    warn "\n\n";
    warn dumper $body;
    warn "\n\n";
    close $fh;
}

__PACKAGE__->meta->make_immutable;

1;
