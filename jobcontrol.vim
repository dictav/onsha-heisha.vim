" :help job_control.txt
function s:JobHandler(job_id, data, event)
  if a:event == 'stdout'
    let str = self.shell.' stdout: '.join(a:data)
  elseif a:event == 'stderr'
    let str = self.shell.' stderr: '.join(a:data)
  else
    let str = self.shell.' exited'
  endif

  call append(line('$'), str)
endfunction
let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_stderr': function('s:JobHandler'),
      \ 'on_exit': function('s:JobHandler')
      \ }
let job1 = jobstart(['bash', '-c', 'echo hoge'], extend({'shell': 'shell 1'}, s:callbacks))
let job2 = jobstart(['bash', '-c', 'for i in {1..10}; do echo hello $i!; sleep 1; done'], extend({'shell': 'shell 2'}, s:callbacks))
