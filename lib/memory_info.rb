module Que::MemoryInfo
  KERNEL_PAGE_SIZE = 4096
  STATM_PATH       = "/proc/#{Process.pid}/statm"
  STATM_FOUND      = File.exist?(STATM_PATH)

  def self.rss
    STATM_FOUND ? (File.read(STATM_PATH).split(' ')[1].to_i * KERNEL_PAGE_SIZE) / (1024 * 1024): 0
  end
end
