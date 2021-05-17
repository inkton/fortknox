
echo $'-- Plan Begin --\n' 2>&1 | tee build.log
terraform plan 2>&1 | tee -a build.log
echo $'-- Plan End  ---\n' 2>&1 | tee -a build.log
echo $'-----------------\n' 2>&1 | tee -a build.log

echo $'-- Apply Begin --\n' 2>&1 | tee -a build.log
terraform apply 2>&1 | tee -a build.log
echo $'-- Apply End ----\n' 2>&1 | tee -a build.log
echo $'-----------------\n' 2>&1 | tee -a build.log
