Feature: Detecting linked asset addition and removal

  Background:
    Given a fixture app "base-app"
    And a file named "config.rb" with:
      """
      activate :sprockets
      sprockets.append_path File.join(root, 'imports')
      """
    And a file named "imports/a.jpg" with:
      """
      """
    And a file named "imports/b.jpg" with:
      """
      """

  Scenario: Link directive or asset-path helper reference added for an asset
    The linked assets will be added to the sitemap

    Given a file named "source/stylesheets/manifest.css.scss" with:
      """
      """
    And the Server is running

    When I go to "/assets/a.jpg"
    Then the status code should be "404"
    When I go to "/assets/b.jpg"
    Then the status code should be "404"

    Given the file "source/stylesheets/manifest.css.scss" content is changed to:
      """
      //= link a.jpg
      body { background: asset_url('b.jpg'); }
      """

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "200"


  Scenario: Refrence to linked file removed, both directive & asset-path helper
    The linked assets are removed from the sitemap

    Given a file named "source/stylesheets/manifest.css.scss" with:
      """
      //= link a.jpg
      body { background: asset_url('b.jpg'); }
      """
    And the Server is running

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "200"

    Given the file "source/stylesheets/manifest.css.scss" content is changed to:
      """
      """

    When I go to "/assets/a.jpg"
    Then the status code should be "404"
    When I go to "/assets/b.jpg"
    Then the status code should be "404"


  Scenario: Asset file with linked assets removed
    The linked assets are removed from the sitemap

    Given a file named "source/stylesheets/manifest.css.scss" with:
      """
      //= link a.jpg
      body { background: asset_url('b.jpg'); }
      """
    And the Server is running

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "200"

    Given the file "source/stylesheets/manifest.css.scss" is removed

    When I go to "/assets/a.jpg"
    Then the status code should be "404"
    When I go to "/assets/b.jpg"
    Then the status code should be "404"


  Scenario: Asset file with linked assets added
    The linked assets are added to the sitemap

    Given the Server is running

    When I go to "/assets/a.jpg"
    Then the status code should be "404"
    When I go to "/assets/b.jpg"
    Then the status code should be "404"


    Given a file named "source/stylesheets/manifest.css.scss" with:
      """
      //= link a.jpg
      body { background: asset_url('b.jpg'); }
      """

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "200"


  Scenario: Asset file with linked assets (linked in other files) removed
    The linked assets remain in the sitemap

    Given a file named "source/stylesheets/base.css.scss" with:
      """
      //= link a.jpg
      """
    And a file named "source/stylesheets/manifest.css.scss" with:
      """
      //= link a.jpg
      //= link b.jpg
      """
    And the Server is running

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "200"

    Given the file "source/stylesheets/manifest.css.scss" is removed

    When I go to "/assets/a.jpg"
    Then the status code should be "200"
    When I go to "/assets/b.jpg"
    Then the status code should be "404"
