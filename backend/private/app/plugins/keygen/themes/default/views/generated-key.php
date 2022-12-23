<chubby-styles>
  <style>
    #Key {
      height: 100vh;
      font-family: monospace;
      font-size: 24px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }
    #Key .value {
      display: block;
      padding: 15px;
      width: 100%;
      text-align: center;
    }
  </style>
</chubby-styles>

<div id="Key">
  <?php foreach ($this->keys as $key) : ?>
    <span class="value"><?php echo $key; ?></span>
  <?php endforeach; ?>
</div>
