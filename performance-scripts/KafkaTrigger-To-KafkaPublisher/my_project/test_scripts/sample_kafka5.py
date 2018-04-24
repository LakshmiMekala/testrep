import mechanize
import time
from kafka import SimpleProducer, KafkaClient, KafkaConsumer
import threading

class Transaction(object):
    def __init__(self):
        self.custom_timers = {}
        kafka = KafkaClient('localhost:9092')
        self.producer = SimpleProducer(kafka)
        self.consumer = KafkaConsumer('subscribepet',
                         group_id='my_group',
                         bootstrap_servers=['localhost:9092'],
                         auto_offset_reset='earliest')
        self.count=0
    
    def run(self):
        t1 = time.time()
        sendMessage = b'{"name": "CAT","%s":"%s"}' % (str(threading.current_thread())[14], self.count)
        #print sendMessage
        self.producer.send_messages(b'publishpet', sendMessage)
        t2 = time.time()
        #consumer.poll()
        #consumer.seek_to_end()
        while True:
            for message in self.consumer:
                #print message.value
                #print "for loop"
                if message.value == sendMessage :
                    #print "success"
                    self.count += 1
                    break    
                #print "outside"
            break           

        t3 = time.time()
        t2t1 = t2-t1
        t3t2 = t3-t2
        self.custom_timers['submit_msg'] = t2t1
        self.custom_timers['msg_processed'] = t3t2