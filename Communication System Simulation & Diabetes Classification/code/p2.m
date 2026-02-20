% Predict labels using exported model
predictedLabels = TrainedModel.predictFcn(diabetes_training);

% True labels (last column of the table)
trueLabels = table2array(diabetes_training(:, end));

correct = sum(predictedLabels == trueLabels);
accuracy_manual = correct / length(trueLabels) * 100;

fprintf('Training-phase accuracy = %.2f%%\n', accuracy_manual)



pred_val = TrainedModel.predictFcn(diabetes_validation);

true_val = table2array(diabetes_validation(:, end));

correct_val = sum(pred_val == true_val);
accuracy_test = correct_val / length(true_val) * 100;

fprintf('Test-phase accuracy = %.2f%%\n', accuracy_test);
