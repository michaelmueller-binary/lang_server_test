use strict;
use warnings;
use feature qw/ say /;
use utf8;

use Sereal qw/ sereal_decode_with_object /;
use IO::Async::Loop;
use IO::Async::Listener;
use Future;

$, = "\t";

my $PORT = 53123;
my $num  = 0;
my $dec  = Sereal::Decoder-> new;
my $loop = IO::Async::Loop-> new;
my $lst  = IO::Async::Listener-> new(
     on_stream => sub {
        my ( $self, $stream ) = @_;
          $stream->configure(
          on_read => sub {
             my ( $self, $buffref, $eof ) = @_;
             #$self->write( $$buffref );
             say ($$buffref);
             $$buffref = "";
             return 0;
          },
       ); 
        $loop-> add( $stream );
        
    }
);
$loop -> add( $lst );
$lst-> listen(
    addr => {
        family   => 'inet',
        socktype => 'stream',
        ip       => '127.0.0.1',
        port     => $PORT,
    },
)->on_done( sub { say "Listening on $PORT..." });

$loop->run;
