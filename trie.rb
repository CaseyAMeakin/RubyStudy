#implement a simple Trie class data structure using hash map

class Node
  
  attr_reader :value, :d
  attr_writer :value, :d
  
  def initialize(value=nil,d = {})
    @value = value
    @d = d
  end
  
end


class Trie
  
  attr_reader :root
  attr_writer :root
  
  def initialize
    @root = Node.new
  end
  
  def add_word(word)
    word = word.split("")
    node = @root
    word.each do |c|
      d = node.d
      if d.has_key?(c)
        node = d[c]
      else
        d[c] = Node.new(c)
        node = d[c]
        node.value = c
      end
    end
  end
  
  def has_word?(word)
    word = word.split("")
    node = @root
    word.each do |c|
      d = node.d
      if d.has_key?(c)
        node = node.d[c]
      else
        return false
      end
    end
    return node
  end

  def next_branch(start_word)
    if node = has_word?(start_word)
      word = start_word
      while node.d.size == 1
        node.d.each do |k,v|
          node = v
          word += node.value
        end
      end
      return [word,node.d.size]
    else
      return nil
    end
  end

  def max_branch_count(stems)
    max_count = 0
    stems.each {|k,v| if v > max_count then max_count = v end}
    return max_count
  end

  def get_all_words
    start_word = ''
    if node=has_word?(start_word)
      stems = {start_word => node.d.size}
    else
      return {}
    end
    while max_branch_count(stems) > 0
      stems_ = stems.dup
      stems_.each do |stem,stem_count|
        if stem_count > 1
          has_word?(stem).d.each do |c,n|
            branch = next_branch(stem+c)
            stems[branch[0]] = branch[1]
          end
          stems.delete(stem)
        end
      end
    end
    return stems.collect { |k,v| k}
  end
  
end



# test program

if __FILE__ == $0

  words = ["go", "got", "goth", "gold", "cat", "cola", "cold"]  
  
  myTrie = Trie.new
  words.each do |word|
    myTrie.add_word(word)
  end

  words += ["goof"]
  words.each do |word|
    if myTrie.has_word?(word)
      puts("word loaded: " + word)
    else
      puts("word not loaded: " + word)
    end
  end
  
  puts("- - - - -")
  #check that words/characters are stored as expected
  puts(myTrie.root.d['g'].value)
  puts(myTrie.root.d['g'].d['o'].value)
  puts(myTrie.root.d['g'].d['o'].d['t'].value)
  puts(myTrie.root.d['g'].d['o'].d['t'].d['h'].value)
  puts(myTrie.root.d['g'].d['o'].d['l'].d['d'].value)

  puts("- - - - -")  
  words = myTrie.get_all_words
  puts(words)
  
end
