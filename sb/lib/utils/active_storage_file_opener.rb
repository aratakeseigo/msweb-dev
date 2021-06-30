class Utils::ActiveStorageFileOpener
  include ActiveStorage::Downloading

  def initialize(file)
    @file = file
  end

  # ActiveStorage::Downloadingを使うためにはblobが必要。
  def blob
    @file.blob
  end

  def open
    download_blob_to_tempfile do |file|
      yield file
    end
  end
end
