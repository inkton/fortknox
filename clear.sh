echo $'-- Clear Begin --\n' 2>&1 | tee clear.log
terraform destroy 2>&1 | tee -a build.log
echo $'-- Clear End  ---\n' 2>&1 | tee -a clear.log
echo $'-----------------\n' 2>&1 | tee -a clear.log

