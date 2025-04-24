# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "aws-eventbridge-to-amazon-q-developer"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------



variable "sns_topic_arn" {
  description = "The ARN of the SNS topic used for notifications, If not provided, topic will create SNS topic it self"
  type        = string
  default     = ""
}

variable "enable_ecs_task_state_event_rule" {
  description = "The boolean flag enabling the EvenBridge Rule for `ECS Task State Change` events. The `detail` section of this rule is configured with `ecs_task_state_event_rule_detail` variable."
  type        = bool
  default     = true
}

variable "enable_ecs_deployment_state_event_rule" {
  description = "The boolean flag enabling the EvenBridge Rule for `ECS Deployment State Change` events. The `detail` section of this rule is configured with `ecs_deployment_state_event_rule_detail` variable."
  type        = bool
  default     = true
}

variable "enable_ecs_service_action_event_rule" {
  description = "The boolean flag enabling the EvenBridge Rule for `ECS Service Action` events. The `detail` section of this rule is configured with `ecs_service_action_event_rule_detail` variable."
  type        = bool
  default     = true
}

variable "ecs_task_state_event_rule_detail" {
  description = "The content of the `detail` section in the EvenBridge Rule for `ECS Task State Change` events. Use it to filter the events which will be processed and sent to Slack."
  type        = any
  default = {
    lastStatus    = ["STOPPED"]
    stoppedReason = [{ "anything-but" : { "prefix" : "Scaling activity initiated by (deployment ecs-svc/" } }] # skip task stopped events triggerd by deployments
  }
}

variable "ecs_deployment_state_event_rule_detail" {
  description = "The content of the `detail` section in the EvenBridge Rule for `ECS Deployment State Change` events. Use it to filter the events which will be processed and sent to Slack."
  type        = any
  default = {
    eventType = ["ERROR"]
  }
}

variable "ecs_service_action_event_rule_detail" {
  description = "The content of the `detail` section in the EvenBridge Rule for `ECS Service Action` events. Use it to filter the events which will be processed and sent to Slack."
  type        = any
  default = {
    eventType = ["WARN", "ERROR"]
  }
}

variable "custom_event_rules" {
  description = "A map of objects representing the custom EventBridge rule which will be created in addition to the default rules."
  type        = any
  default     = {}

  validation {
    error_message = "Each rule object should have both 'detail' and 'detail-type' keys."
    condition     = alltrue([for name, rule in var.custom_event_rules : length(setintersection(keys(rule), ["detail", "detail-type"])) == 2])
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


