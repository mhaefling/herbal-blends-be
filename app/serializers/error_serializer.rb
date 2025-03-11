class ErrorSerializer
  def self.error_message(status, title = "Error", message, detail)
    {
      error: {
        status: status.to_s,
        title: title,
        message: message,
        detail: detail
      }
    }
  end
end