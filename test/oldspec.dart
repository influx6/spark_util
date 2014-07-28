library specs;

import 'package:spark_utils/spark_utils.dart';
import 'package:hub/hub.dart';

void main(){
  
  var sparce = SparceList.create();
  var sfn = SplitterFn.create();
  var sreg = SplitRExp.create();
  var sm = SparceMap.create();
  
  sparce.add(1,'a');
  sparce.add(0,'b');
  sparce.add(3,'ba');

  sfn.port('in:splitfn').send((n) => n.split(new RegExp(r'{{|}}')));
  sfn.port('in:data').send('brilliant blow {{name}}');
  sfn.port('out:splits').tap(print);

  sreg.port('in:rexp').send('{{|}}');
  sreg.port('in:data').send('{{<article>#name</article>}}{{<tag></tag>}}');
  sreg.port('out:splits').tap(print);

  sm.port('out:mapped').tap(print);
  sm.port('in:split').send([1,323,32,21]);
  sm.port('in:combine').send(sparce);
  
  sreg.port('out:splits').bindPort(sm.port('in:split'));

  sreg.port('in:data').send(""" 
      {{
        collection#{::keys 
          
          <article>::keys:key</article>

        }
      }}
      {{
        <section>#root</section>
      }}
  """);

}
