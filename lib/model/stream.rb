class Stream
  include MongoMapper::EmbeddedDocument

  before_destroy :remove_entries # doesn't seem to work?

  timestamps!

  key :key,          String,  required: true
  key :title,        String,  required: true
  key :url,          String,  required: true
  key :details_url,  String
  key :max_details,  Integer, default: 5

  belongs_to :parser

  def remove_entries
    Entry.destroy_all(stream_id: self._id)
  end
end
