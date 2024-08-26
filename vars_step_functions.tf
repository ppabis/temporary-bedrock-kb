variable "step_function_ver" {
  description = "Version of the Step Function to use"
  type        = string
  default     = "v2"
  validation {
    condition     = var.step_function_ver == "v1" || var.step_function_ver == "v2"
    error_message = "Step Function version must be either 'v1' or 'v2'"
  }
}

/**
 * CloudFormation stack names
*/

variable "oss_collection_stack_name" {
  description = "Name of the stack that contains the OpenSearch collection"
  type        = string
  default     = "my-collection"
}

variable "kb_stack_name" {
  description = "Name of the stack that contains the knowledge base"
  type        = string
  default     = "my-knowledge-base"
}

/*
 * Models to use for embedding and inference
 * Remember to keep them in the same region.
*/

variable "embedding_model_arn" {
  description = "ARN of the model that should perform the embedding (same region!)"
  type        = string
  default     = "arn:aws:bedrock:us-west-2::foundation-model/cohere.embed-multilingual-v3"
}

variable "inference_model_arn" {
  description = "ARN of the model that should perform the inference (same region!)"
  type        = string
  default     = "arn:aws:bedrock:us-west-2::foundation-model/anthropic.claude-3-haiku-20240307-v1:0"
}

variable "inference_temperature" {
  description = "Temperature to use for sampling in the inference model"
  type        = number
  default     = 0.7
}

variable "inference_top_p" {
  description = "Top P value to use for sampling in the inference model"
  type        = number
  default     = 0.95
}

variable "inference_max_tokens" {
  description = "Maximum number of tokens to generate in the inference model"
  type        = number
  default     = 1024
}

/**
 * Names of the parameters used in the index, no need to change
*/
variable "vector_index_name" {
  description = "Name of the index in the OpenSearch collection"
  type        = string
  default     = "myvectorindex"
}

variable "vector_name" {
  description = "Name of the vector field in the OpenSearch collection"
  type        = string
  default     = "embedding"
}

variable "vector_dimensions" {
  description = "Number of dimensions in the vector field"
  type        = number
  default     = 1024
}

variable "text_name" {
  description = "Name of the text field in the OpenSearch collection"
  type        = string
  default     = "chunk"
}

variable "metadata_name" {
  description = "Name of the metadata field in the OpenSearch collection"
  type        = string
  default     = "bedrock-meta"
}
