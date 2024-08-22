from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import boto3, json, os
from pprint import pprint

# Setup the AWS client globally
Oss = boto3.client('opensearchserverless')

# Setup AWS credentials that can be passed later to OpenSearch endpoint
Credentials = boto3.Session().get_credentials()
AwsAuth = AWS4Auth(
  Credentials.access_key,
  Credentials.secret_key,
  os.environ['AWS_DEFAULT_REGION'],
  'aoss',
  session_token=Credentials.token
)

def create_vector_index(vectorName, dimensions, textName, metadataName):
  """
  Creates an index compatible with Bedrock Knowledge Base.
  """
  # First we define an empty template for readability
  template = {
    'settings': {
      'index': {
        'knn': True,
        'knn.algo_param.ef_search': 512
      }
    },
    'mappings': {
      'properties': {}
    }
  }
  
  # The embeddings vector
  template['mappings']['properties'][vectorName] = {
      'type': "knn_vector",
      'dimension': dimensions,
      'method': {
        'name': "hnsw",
        'engine': "faiss",
        'parameters': {},
        'space_type': "l2"
      }
    }
  
  # The text chunk and metadata
  template['mappings']['properties'][textName] = { 'type': "text", 'index': True }
  template['mappings']['properties'][metadataName] = { 'type': "text", 'index': False }
  return json.dumps(template)

def lambda_handler(event, context):
  # Create a request for new index creation
  data = create_vector_index(event['vectorName'], event['vectorDimensions'], event['textName'], event['metadataName'])
  # Step Functions pass state doesn't work as expected by data flow simulator 🤔 as it outputs a list instead of a single value
  aossEndpoint = event['aossEndpoint'][0] if isinstance(event['aossEndpoint'], list) else event['aossEndpoint']
  endpoint = aossEndpoint.replace('https://', '')
  indexName = event['vectorIndexName']
  
  # Create AOSS client
  client = OpenSearch(
    hosts=[{'host': endpoint, 'port': 443}],
    http_auth=AwsAuth,
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection,
    timeout=300
  )

  response = client.indices.create(index=indexName, body=data)

  pprint(response)

  get_index = client.indices.get(index=indexName)
  
  pprint(get_index)
  
  # Return the response from the API directly into Lambda
  if 'acknowledged' in response and response['acknowledged']:
    return {
      'statusCode': 200,
      'body': json.dumps(response)
    }
  else:
    return {
        'statusCode': 500,
        'body': json.dumps(response)
    }
