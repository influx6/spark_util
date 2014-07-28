library specs;

import 'package:spark_utils/spark_utils.dart';
import 'package:hub/hub.dart';

void main(){
  

  SparkUtils.registerComponents();

  var atom = SparkFlow.registry.generate('sparkutils/affectors/atomic');
  var atom2 = SparkFlow.registry.generate('sparkutils/affectors/atomic');
  var digit = SparkFlow.registry.generate('sparkutils/transformers/digittag');
  var digit2 = SparkFlow.registry.generate('sparkutils/transformers/digittag');
  var inject = SparkFlow.registry.generate('sparkutils/affectors/packetinjector');

  inject.port('out:eject').tap(print);

  atom.port('out:atom').bindPort(digit.port('in:data'));
  atom2.port('out:atom').bindPort(digit2.port('in:data'));

  digit.port('out:packet').bindPort(inject.port('in:packet'));
  digit2.port('out:packet').bindPort(inject.port('in:packet'));

  digit.port('out:key').bindPort(inject.port('in:atomKey'));
  digit2.port('out:key').bindPort(inject.port('in:atomKey'));

  digit2.port('in:digit').send(1);
  digit.port('in:digit').send(3);


  var join = SparkFlow.registry.generate('sparkutils/objects/join');

  join.port('out:join').tap(print);
  inject.port('out:eject').bindPort(join.port('in:values'));

  atom.port('in:data').send('alex');
  atom2.port('in:data').send('dorcas');

  atom2.port('in:data').send('magaret');
  atom.port('in:data').send('john');

  join.port('in:delimiter').send('.');

  atom2.port('in:kick').send(true);
  atom.port('in:kick').send(true);


}
