library spark_utils;

import 'package:sparkflow/sparkflow.dart';
import 'package:hub/hub.dart';

class SparkUtils{
  static void register(){

      Sparkflow.createRegistry('spark.utils',(r){
        
         r.addMutation('utils/applyfn',(e){
            e.meta('desc','applies a function to all inputs');

            e.createSpace('apply');
            e.makeInport('apply:fn');
            e.makeInport('apply:in');
            e.makeOutport('apply:out');

            e.port('apply:in').pause();

            e.port('apply:fn').forceCondition(Valids.isFunction);
            e.port('apply:fn').tap((n){
              e.sd.update('fn',n.data);
              e.port('apply:in').resume();
            });

            e.port('apply:in').tap((n){
              e.port('apply:out').send(e.sd.get('fn')(n.data));
            });

         });

         r.addMutation('utils/filterfn',(e){
          
            e.createSpace('filter');
            e.makeInport('filter:fn');
            e.makeInport('filter:in');
            e.makeOutport('filter:out');

            e.port('filter:in').pause();

            e.port('filter:fn').forceCondition(Valids.isFunction);
            e.port('filter:fn').tap((n){
              e.sd.update('fn',n.data);
              e.port('filter:in').resume();
            });

            e.port('filter:in').tap((n){
              bool state = e.sd.get('fn')(n.data);
              if(!!state) e.port('filter:out').send(n);
            });
         });


         r.addMutation('utils/consolepackets',(e){
            e.meta('desc','outputs all streams to console screen');

            e.createSpace('prt');
            e.makeInport('prt:in');
            e.makeOutport('prt:out');

            e.port('prt:out').tap((n) => print(n));

            e.loopPorts('prt:in','prt:out');
         });
         
         r.addMutation('utils/consoledata',(e){
            e.meta('desc','outputs all streams to console screen');

            e.createSpace('prt');
            e.makeInport('prt:in');
            e.makeOutport('prt:out');

            e.port('prt:out').tap((n) => print(n.data));

            e.loopPorts('prt:in','prt:out');
         });

      });
  }
}
