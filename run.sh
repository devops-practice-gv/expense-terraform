#File to take care of saving tfstate file for dev and prod at different folders
# because the terraform backend block does not support variables.

env=$1
action=$2

if [ -z "$env" ]; then
  echo "Input the env (dev|qa|stage|prod)"
  exit 1
fi

if [ -z "$action" ]; then
  echo "Input the action (apply/destroy)"
  exit 1
fi

rm -rf .terraform/terraform.tfstate
terraform init -backend-config=env-"$env"/state.tfvars
terraform $action -var-file=env-"$env"/main.tfvars -auto-approve
