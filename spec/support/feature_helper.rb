module FeatureHelper
  def screenshot(dir_path: 'tmp/capybara', file_name: "#{Time.zone.now.strftime('%Y-%m-%d_%H:%M:%S.%2N')}.png")
    page.save_screenshot("#{File.join(dir_path, file_name)}", full: true)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

private

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
