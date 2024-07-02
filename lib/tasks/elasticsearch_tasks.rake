namespace :elasticsearch do
    desc "Create Elasticsearch index for messages"
    task create_index: :environment do
        Message.__elasticsearch__.create_index! force: true
    end

    desc "Reindex all messages"
    task reindex: :environment do
        Message.__elasticsearch__.create_index! force: true
        Message.import 
    end
end

