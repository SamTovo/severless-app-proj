resource "aws_cognito_user_pool" "pool" {
    name = "chatpool"

    username_attributes = ["email", "username"]
    auto_verified_attributes = ["email"]

    mfa_configuration = "OFF"

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }
    }

    admin_create_user_config {
        allow_admin_create_user_only = false
    }

}

resource "aws_cognito_user_pool_client" "website" {
    name         = "website"
    user_pool_id = aws_cognito_user_pool.pool.id

    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
    ]

    prevent_user_existence_errors = "ENABLED"
}