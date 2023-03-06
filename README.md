# Getting Started

1. Add the required environment variables
    ```bash
    cat <<EOF >> config/application.yml
    ZEPTO_ENVIRONMENT=sandbox
    ZEPTO_API_KEY=your_key
    ZEPTO_ADAPTER_CLASS=Zepto::TestAdapter
    EOF
    ```
1. Bundle install
    ```
    bundle install
    ```
1. Create the db and seeds
    ```bash
    rails db:create && rails db:migrate && rails db:seed
    ```
1. Run the app
    ```bash
    overmind start -f Procfile.dev
    ```
