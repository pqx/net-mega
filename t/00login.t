use Test::More;

use lib '../lib';
require_ok('Net::MEGA');
use Data::Dumper;

my $mega = Net::MEGA->new(path_prefix => '/Root/tests/');
my @ls = $mega->ls('camel/camel.png');
$mega->get('camel/camel.png','/tmp/camel.png');


warn Dumper [@ls];


done_testing();