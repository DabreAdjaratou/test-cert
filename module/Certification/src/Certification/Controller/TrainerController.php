<?php

namespace Certification\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Certification\Model\Trainer;
use Certification\Form\TrainerForm;

class TrainerController extends AbstractActionController {

    protected $TrainerTable;

    public function getTrainerTable() {
        if (!$this->TrainerTable) {
            $sm = $this->getServiceLocator();
            $this->TrainerTable = $sm->get('Certification\Model\TrainerTable');
        }
        return $this->TrainerTable;
    }

    public function indexAction() {

        $trainers = $this->getTrainerTable()->fetchAll();
        $view = new ViewModel(array('trainers' => $trainers));
        $view->setTemplate("certification/trainer/index.phtml");
        return $view;
    }

    public function addAction() {
        $form = new TrainerForm();
        $form->get('submit')->setValue('Add');
//
        $request = $this->getRequest();
        if ($request->isPost()) {
            $trainer = new Trainer();
            $form->setInputFilter($trainer->getInputFilter());
            $form->setData($request->getPost());

            if ($form->isValid()) {
                $trainer->exchangeArray($form->getData());
//                 print_r($trainer);
                $this->getTrainerTable()->saveTrainer($trainer);

                return $this->redirect()->toRoute('trainer');
            }
        }

        return array('form' => $form);
    }

    public function editAction() {
        $trainer_id = (int) $this->params()->fromRoute('trainer_id', 0);
        if (!$trainer_id) {
            return $this->redirect()->toRoute('trainer', array(
                        'action' => 'add'
            ));
        }

        try {
            $trainer = $this->getTrainerTable()->getTrainer($trainer_id);
        } catch (\Exception $ex) {
            return $this->redirect()->toRoute('trainer', array(
                        'action' => 'index'
            ));
        }

        $form = new TrainerForm();
        $form->bind($trainer);
        $form->get('submit')->setAttribute('value', 'Edit');

        $request = $this->getRequest();
        if ($request->isPost()) {
            $form->setInputFilter($trainer->getInputFilter());
            $form->setData($request->getPost());

            if ($form->isValid()) {
                $this->getTrainerTable()->saveTrainer($trainer);

                return $this->redirect()->toRoute('trainer');
            }
        }

        return array(
            'trainer_id' => $trainer_id,
            'form' => $form,
        );
    }

}