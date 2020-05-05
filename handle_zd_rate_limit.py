import time,requests, sys

  user="YOUREMAIL@YOURDOMAIN.COM/token"
  pwd="YOURPASSWORD"
  session = requests.Session()
  #session.auth = (user,pwd)
  #session.headers.update({'X-test': 'WTF'})
  session.headers.update({'Authorization': 'Basic YOURBASE64ENCODEDPASSWORD'})

  url='https://YOURZENDESKDOMAIN.zendesk.com/api/v2/organizations/' + str(orgID) + '.json'
  #print("DEBUG: URL " + url)
 
  throttled = 0
  rt = 1

  response=session.get(url)
  if response.status_code == 429:
      throttled = 1
      rt = response.headers['retry-after']
  while (throttled):
    print("DEBUG: Throttled, waiting " + rt + " seconds")
    time.sleep(float(rt))
    response=session.get(url)
    if response.status_code != 429:
      throttled=0
  if response.status_code != 200:
    print('Status:', response.status_code, 'Problem with the request. Exiting.')
    print('DEBUG:' + response.text);
    exit()

