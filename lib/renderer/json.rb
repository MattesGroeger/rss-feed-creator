module Renderer

  def self.json(output)
    result = {}
    result[:entries] = []
    result[:streams] = output.stream_ids.map { |s_id|
      result[:entries].concat(Entry.where(stream_id: s_id)
        .sort(:updated_at.desc).map { |entry|
          entry.serializable_hash()
        })
      website = Website.where('streams._id' => s_id).first
      website.streams.select { |s|
        s._id == s_id
      }.first.serializable_hash(
        except: [:max_details, :parser_id]
      ).merge({website: website.serializable_hash(except: :streams)})
    }
    JSON.pretty_generate(result)
  end

end
