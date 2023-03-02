#importing azure  python 
import azure.functions as func
import json
import logging

def main(req: func.HttpRequest, inputDocument: func.DocumentList,  outputDocument: func.Out[func.DocumentList]) ->str:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.route_params.get('name')
    for name in inputDocument:
        logging.info(name.to_json())
    if name:
        newdocs = func.DocumentList()
        logging.info('Listing documents from cosmos db utilisting the input binding listed in the definition....')
        #converting to an Json document
        visitorname = name.to_json()
        #load json document
        visitor = json.loads(visitorname)
        logging.info('loading json document complete')
        #searching for key "visitor"
        key = "visitor"
        if key in visitor:
            visitor[key] +=1
        newdocs_load_json= json.dumps(visitor)
        newdocs.append(func.Document.from_json(newdocs_load_json))
        outputDocument.set(newdocs)
        return func.HttpResponse(f"{newdocs_load_json}")