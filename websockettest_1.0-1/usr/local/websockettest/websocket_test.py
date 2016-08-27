import websocket
import sys, getopt
 
def on_error(ws, error):
    print(error)
    sys.exit(2)
 
def main(argv):
    print "Starting..."
    try:
        opts, args = getopt.getopt(argv,"c:r:")
    except getopt.GetoptError:
        print 'Usage: websocket_test.py -c <connects number> -r <requests number>'
        sys.exit(2)
    connects = None
    requests = None
    for o, a in opts:
        if o == '-c':
            connects = int(a)
        elif o == '-r':
            requests = int(a)
    if (connects is None) or (requests is None) :
        print 'Usage: websocket_test.py -c <connects number> -r <requests number>'
        sys.exit(2)
    for c in range(0,connects):
        ws= websocket.WebSocket(on_error=on_error)
        target_url = "ws://localhost/echo"
        print "Connecting to :"+ target_url
        ws.connect(target_url)
        for r in range(0,requests):
            test_string="Hello"
            ws.send(test_string)
            result = ws.recv()
            if test_string != result:
                print "Testing failed. Sent: "+test_string+". Received: "+result
                sys.exit(2)
        print "Done echo requests: " + str(requests)
        print "Disconnecting"
        ws.close()
    print "Testing done. Status: SUCCESS"
if __name__ == "__main__":
    main(sys.argv[1:])
