import os
import json
import urllib3


def init(event, context):

    if os.environ["debug"]==True:
        print("event:")
        print(str(event))
        print("context:")
        print(str(context))

    resp = sendMessage(formatCard(event['Records'][0]['Sns']['Message']))
    
    return({
        "status_code": resp.status,
        "response": resp.data
    })

def sendMessage(msg):
    url = os.environ["url_teams_webhook"]
    encoded_msg = json.dumps(msg).encode('utf-8')
    http = urllib3.PoolManager()
    resp = http.request('POST',url, body=encoded_msg, headers={'Content-Type': 'application/json'})
    return resp

def formatCard(message):
    facts = []
    message = json.loads(message)
    activityTitle = activitySubtitle = ''
    
    if 'AlarmName' in message:
        activityTitle = '{an}'.format(an=message['AlarmName'])

    if 'OldStateValue' in message:
        if message['OldStateValue'] == 'OK':
            activitySubtitle += '<font color="red">'
        else:
            activitySubtitle += '<font color="green">'
        activitySubtitle += '<b>{osv}</b>'.format(osv=message['OldStateValue'])
    if 'NewStateValue' in message:
        activitySubtitle += '<b> -> {nsv}</b>'.format(nsv=message['NewStateValue'])
    activitySubtitle += '</font>'
    
    if 'AlarmDescription' in message:
        activityText = message['AlarmDescription']
    
    if 'StateChangeTime' in message:
        facts.extend([{"name": "StateChangeTime", "value": message['StateChangeTime']}])
    if 'AWSAccountId' in message:
        facts.extend([{"name": "AWSAccountId", "value": '{ai} / {rg}'.format(ai=message['AWSAccountId'], rg=message['Region'])}])
    if 'NewStateReason' in message:
        facts.extend([{"name": "NewStateReason", "value": message['NewStateReason']}])
    if 'Trigger' in message:
        if 'Namespace' in message['Trigger']:
            facts.extend([{"name": "Namespace", "value": message['Trigger']['Namespace']}])
        if 'Dimensions' in message['Trigger']:
            dims = ''
            for dimension in message['Trigger']['Dimensions']:
                if 'name' in dimension and 'value' in dimension:
                    dims+= '{dn} : {dv}<br/>'.format(dn=str(dimension['name']), dv=str(dimension['value']))
            facts.extend([{"name": "Dimensions", "value": str(dims)}])


    card = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "themeColor": "0076D7",
        "summary": activityTitle,
        "sections": [{
            "startGroup": 0,
            "activityTitle": activityTitle,
            "activitySubtitle": activitySubtitle,
            "activityText": activityText,
            "facts": facts,
            "markdown": "true"
        }],
        "potentialAction": [{
            "@type": "OpenUri",
            "name": os.environ["consigne_title"],
            "targets": [{ "os": "default", "uri": '{url}{tgt}'.format(url=os.environ["consigne_url"], tgt=activityTitle) }]
        }]
    }
    return card
