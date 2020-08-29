package MyApp::Controller::Callback;
use Moose;
use namespace::autoclean;

use uni::perl       qw| :dumper |;
use Encode          qw| encode decode |;
use JSON::XS        qw| decode_json encode_json |;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config( namespace => 'callback' );

sub base : Chained('') PathPart('callback') CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{json_data} = { success => 1, };
}

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    $c->req->body->DESTROY if $c->req->body && $c->req->body->filename;
    $c->stash(current_view => 'JSON');
    return;
}

__PACKAGE__->meta->make_immutable;

1;
