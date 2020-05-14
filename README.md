# jekyll-s3-action

This action is meant to be used when building a jekyll site that is to be pushed to an S3 buckets.
## How to Use

**1. Create secrets**

Create a AWS_ACCESS_KEY_ID and a AWS_SECRET_ACCESS_KEY secret using your repo's `secrets` settings.  The value should be the associated keys from the IAM user who has access to the S3 bucket you're pushing into.

**2. Add steps to your workflow**

```yaml
  steps:
  # ...
  - name: Build and Deploy
    uses: kshehadeh/jekyll-s3-action@master
    env: 
      AWS_ACCESS_KEY_ID: ${{secrets.AWS_ACCESS_KEY_ID}}
      AWS_SECRET_ACCESS_KEY: ${{secrets.AWS_SECRET_ACCESS_KEY}}
      S3_BUCKET_NAME: "doc_bucket"
      S3_BUCKET_PATH: "engineering/runbooks"    
  # ...
```

**3. Profit**

## Output

When this runs you should see something like this:
```
🚩 Checking for expected environment variables
   ✅ SOURCE found: ./_site
   ✅ AWS_ACCESS_KEY_ID found: AK... 
   ✅ AWS_SECRET_ACCESS_KEY found: mq... 
   ✅ S3_BUCKET_NAME found: doc_bucket
   ✅ S3_BUCKET_PATH found: engineering/runbooks


🚩 Checking working directory for expected files(/github/workspace)
   ✅ Found jekyll config file


🚩 Installing bundle gems
   ✅ Completed bundle install


🚩 Building jekyll site
   ✅ Jekyll build done


🚩 Publishing ./_site to S3 bucket named doc_bucket/engineering/runbooks
   ✅ Published to s3\n
```


## Environment Variables

### `AWS_ACCESS_KEY_ID`
This is the access key for the IAM user that has write access to the target S3 bucket.  This is secret and should not be shared.

### `AWS_SECRET_ACCESS_KEY`
This is the secret access key for the IAM user that has write access to the target S3 bucket.  This is secret and should not be shared.

### `S3_BUCKET_NAME`
This is the name of the bucket. As in:
```
s3://<S3_BUCKET_NAME>/...
```

Do not include the prefix or the path, or any slashes in this variable.  The scheme will be prepended and the path is taken from the `S3_BUCKET_PATH`

### `S3_BUCKET_PATH`
This is the path to copy the data into (everything after the bucket name). As in:
```
s3://<S3_BUCKET_NAME>/<S3_BUCKET_PATH>/
```
Note that you should **not have a starting or ending slash** in the path variable.
